# redMine - project management software
# Copyright (C) 2006-2007  Jean-Philippe Lang
#
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License
# as published by the Free Software Foundation; either version 2
# of the License, or (at your option) any later version.
# 
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
# 
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.

module Gradesheet
  module DefaultData
    class DataAlreadyLoaded < Exception; end

    module Loader
      class << self
        # Returns true if no data is already loaded in the database
        # otherwise false
        def no_data?
          !StaticData.find(:first, :conditions => { :name => 'SITE_NAME' }) &&
            !StaticData.find(:first, :conditions => { :name => 'TAG_LINE' }) &&
            !User.find(:first, :conditions => { :login => 'admin' }) 

        end
        
        # Loads the default data
        # Raises a RecordNotSaved exception if something goes wrong
        def load(lang=nil)
          raise DataAlreadyLoaded.new("Some configuration data is already loaded.") unless no_data?

          StaticData.transaction do
            # Static Data
            StaticData.create!(:name => 'SITE_NAME', :value => 'School Name')
            StaticData.create!(:name => 'TAG_LINE', :value => 'The Best School Ever!')

            # Site Data
            site = Site.create!(:name => 'Main Campus', :school_id => 1)

            # Administrator user
            Teacher.create!(:login => 'admin', :first_name => 'Admin', :last_name => 'Admin',
                         :site => site, :is_admin => true, :password_salt => Authlogic::Random.hex_token,
                         :password => 'admin', :password_confirmation => 'admin', :email => 'admin@example.com' )
          end
        end
      end
    end
  end
end
