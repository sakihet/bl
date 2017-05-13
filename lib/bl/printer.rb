module Bl
  module Printer
    module_function

    def print_response(resource, res)
      case resource
      when :issue
        puts formatter.render(res, fields: ISSUE_FIELDS)
      else
        raise 'invalid resource error'
      end
    end
  end
end
