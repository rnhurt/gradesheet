class CorrectAssignmentDueDates < ActiveRecord::Migration
  def self.up
    # Default all NULL due_dates to the record create date
    execute "UPDATE assignments SET due_date = created_at WHERE due_date IS NULL;"
  end

  def self.down
    # There really is no way to reverse this, nor any need to
  end
end
