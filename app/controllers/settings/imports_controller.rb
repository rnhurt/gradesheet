class Settings::ImportsController < SettingsController
  require 'csv'

  # Import data into the database using parameter based inputs.  This allows us
  # to re-use the same 'create' action for different types of data.
  def create
    
    @parsed_file=CSV::Reader.parse(params[:import][:file])
    @import = User.new
    @valid_records = 0
    @record_counter = 0
    import_type = params[:import_type]

    # Open a database transaction so that we can roll back everything if there
    # is an error of some type.  This keeps the database consistant and allows
    # the user to fix errors progressivly.
    ActiveRecord::Base.transaction do
      # Since getting data from the user is "risky" and prone to errors/bad data
      # we are going to wrap this up in a begin..rescue block.  This will allow
      # us to deal with errors in a nice way.
      begin
        # Parse the CSV file and create new users
        @parsed_file.each do |row|
          @record_counter += 1
          
          # Check for empty lines
          next if row.length < 2
          
          # Create and save the user record
          create_new_user(import_type, row)
      end

      rescue CSV::IllegalFormatError => exc
        # Something is wrong with the file
        @import.errors.add_to_base("The file is not in CSV format - (#{exc.message})")
        @import.errors.add_to_base("Please check the file and try again.")
        flash.now[:error] = "Import failed."
        break    
      rescue Exception => exc
        # Something bad happened, but we don't know what it is
        @import.errors.add_to_base("Import error - (#{exc.message})")
        flash.now[:error] = "Import failed."
        break    
      end
      
      # If there were any errors in the import file rollback the transaction
      if !@import.errors.empty?
        raise ActiveRecord::Rollback
      end
    end      
  
    # Inform the user and go back to the main screen
    if @import.errors.empty? && @valid_records > 0
      flash.now[:success] = "Successfully imported #{@valid_records} new records."
    else
      flash.now[:error] = "Import failed with #{@import.errors.length} invalid records."
    end
    render :action => 'index'
  end


  private
  
  # Given an import_type ('students', 'teachers', etc.) and a row of valid data,
  # build a Create statement and insert it into the database.  It also counts
  # the 'bad' records and performs a garbage collection every so often.
  def create_new_user(import_type, row)
    # Create a random password
    password = Authlogic::CryptoProviders::Sha512.encrypt(row[0] + Authlogic::Random.hex_token)

    # We can expect exceptions when processing user provided data, so we need
    # to deal with it and store the information for later display.
    begin    
      case import_type
        when 'students'      
          # Create a new student record and save it
          record = Student.create!(
            :login      => row[0],
            :first_name => row[1],
            :last_name  => row[2],
            :email      => row[3],
            :class_of   => row[4],
            :homeroom   => row[5],
            :site       => Site.find_by_name(row[6]),
            :password   => password,
            :password_confirmation  => password
          )
        when 'teachers'
          # Create a new teacher record and save it
          record = Teacher.create!(
            :login      => row[0],
            :first_name => row[1],
            :last_name  => row[2],
            :email      => row[3],
            :site       => Site.find_by_name(row[4]),
            :password   => password,
            :password_confirmation  => password
          )
        else
          # Bad import type
          raise "unknown import type"
      end
      
      # Check for failures
      if record.save
        @valid_records += 1
        GC.start if @valid_records%50==0
      end

    rescue ActiveRecord::RecordInvalid => exc
      # This was a bad record, record it as a failure and move on
      @import.errors.add_to_base("record ##{@record_counter} - #{exc.message}")
    end
    
  end
  
  
end
