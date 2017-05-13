module Bl
  module Printer
    module_function

    def print_response(resource, res)
      case resource
      when :issue
        puts formatter.render(printable_issues(res.body), fields: ISSUE_FIELDS)
      else
        raise 'invalid resource error'
      end
    end

    def printable_issues(ary)
      ary = Array(ary)
      ary.each do |v|
        v.issueType = v.issueType.name
        v.assignee = v.assignee.name if v.assignee
        v.status = v.status.name
        v.priority = v.priority.name
        v.startDate = format_date(v.startDate)
        v.dueDate = format_date(v.dueDate)
        v.created = format_datetime(v.created)
        v.updated = format_datetime(v.updated)
      end
      ary
    end
  end
end
