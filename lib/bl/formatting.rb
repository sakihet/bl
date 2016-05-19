module Bl
  module Formatting
    module_function

    def colorize_type(name, color)
      Paint[name, :white, color]
    end

    def colorize_priority(id, name)
      case id
      when 2
        Paint[name, :black, '#ffcccc']
      when 3
        Paint[name, :black, '#ccccff']
      when 4
        Paint[name, :black, '#ccffcc']
      else
        raise 'error'
      end
    end

    def colorize_status(id, name)
      case id
      when 1
        Paint[name, :black, '#ffcccc']
      when 2
        Paint[name, :black, '#acd9d3']
      when 3
        Paint[name, :black, '#d3e0ef']
      when 4
        Paint[name, :black, '#c2d3a3']
      else
        raise 'error'
      end
    end

    def print_issue(issue)
      puts [
        colorize_type(issue.issueType.name, issue.issueType.color),
        issue.issueKey,
        issue.summary,
        colorize_priority(issue.priority.id, issue.priority.name),
        issue.created,
        issue.dueDate,
        issue.updated,
        issue.createdUser.name,
        issue.assignee&.name,
        colorize_status(issue.status.id, issue.status.name)
      ].join("\t")
    end
  end
end
