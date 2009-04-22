class Settings::ImportsController < SettingsController
  require 'csv'

  def index
  end

  def show
  end

  def new
  end

  def edit
  end

  def create
    @parsed_file=CSV::Reader.parse(params[:dump][:file])
    @import = User.new
    valid_records = 0
    record_counter = 0    

    # Open a database transaction
    ActiveRecord::Base.transaction do
      # Parse the CSV file and create new users
      @parsed_file.each do |row|
        record_counter += 1
        # Create a random password
        password = Authlogic::CryptoProviders::Sha512.encrypt(row[0] + Authlogic::Random.hex_token)

        # We can expect exceptions when processing user provided data, so we need
        # to deal with it and store the information for later display.
        begin          
          # Create a new student record and save it
          student = Student.create!(
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
          
          # Check for failures
          if student.save
            valid_records += 1
            GC.start if valid_records%50==0
          end
          
        rescue ActiveRecord::RecordInvalid => exc
          # This was a bad record, record it as a failure and move on
          @import.errors.add_to_base("record ##{record_counter} : #{exc.message}")
        end
      end
      
      # If there were any errors in the import file rollback the transaction
      if !@import.errors.empty?
        raise ActiveRecord::Rollback
      end
    end      
  
    # Inform the user and go back to the main screen
    if @import.errors.empty?
      flash.now[:success] = "CSV Import Successful, #{valid_records} new Students added to system"
    else
      flash.now[:error] = "Import failed.  We found #{@import.errors.length} invalid records in the import file."
    end
    render :action => 'index'
  end

  def update
  end

  def destroy
  end
  
end
