module Bl
  module Formatting
    module_function

    ACTIVITY_TYPES = {
      1 => 'Issue Created',
      2 => 'Issue Updated',
      3 => 'Issue Commented',
      4 => 'Issue Deleted',
      5 => 'Wiki Created',
      6 => 'Wiki Updated',
      7 => 'Wiki Deleted',
      8 => 'File Added',
      9 => 'File Updated',
      10 => 'File Deleted',
      11 => 'SVN Committed',
      12 => 'Git Pushed',
      13 => 'Git Repository Created',
      14 => 'Issue Multi Updated',
      15 => 'Project User Added',
      16 => 'Project User Deleted',
      17 => 'Comment Notification Added',
      18 => 'Pull Request Added',
      19 => 'Pull Request Updated',
      20 => 'Comment Added on Pull Request'
    }

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

    def print_activity(a)
      puts [
        ACTIVITY_TYPES[a.type],
        a.content.inspect,
        a.createdUser.name,
        a.created
      ].join("\t")
    end
  end
end
