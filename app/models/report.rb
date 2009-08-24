# Contains information about report objects and their permissions
class Report

  def self.all
    # Define the structure of a report object
    report = Struct.new(:name, :menuname, :restricted)

    # Build the array of valid reports
    return [
      report.new("report_card", "Report Card", false),
      report.new("student_transcript", "Student Transcript", false),
      report.new("student_roster", "Student Roster", false),
      report.new("password_reset", "Password Reset", true),
    ]
  end

  # Find the first report that matches a name
  def self.find_by_name(param)
    reports = Report.all
    reports.delete_if{|r| r.name != param}
    return reports.first
  end
end
