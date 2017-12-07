module Bl
  module Commands
    class Issue < Command
      def initialize(*)
        @config = Bl::Config.instance
        @url = 'issues'
        super
      end

      desc 'add [SUBJECT...]', 'add issues'
      options ISSUE_BASE_ATTRIBUTES
      def add(*subjects)
        subjects.each do |s|
          issue_default_options = @config[:issue][:default]
          res = request(:post,
            'issues',
            issue_default_options.merge({summary: s}).merge(delete_class_options(options.to_h))
          )
          puts '💡 issue added'
          print_response(res, :issue)
        end
      end

      desc 'close [KEY...]', 'close issues'
      def close(*keys)
        keys.each do |k|
          res = request(:patch, "issues/#{k}", statusId: 4)
          puts '🎉 issue closed'
          print_response(res, :issue)
        end
      end

      desc 'count', 'count issues'
      options ISSUES_PARAMS
      def count
        puts request(:get, 'issues/count', delete_class_options(options.to_h)).body.count
      end

      desc 'edit KEY', "edit issues' description by $EDITOR"
      def edit(key)
        issue_description = request(:get, "issues/#{key}").body.description
        file = Tempfile.new
        file.puts(issue_description)
        file.close
        begin
          file.open
          system("$EDITOR #{file.path}")
          new_content = file.read
          request(:patch, "issues/#{key}", description: new_content)
          puts "issue #{key} updated."
        ensure
          file.close
          file.unlink
        end
      end

      desc 'list', 'list issues by typical ways'
      option :all
      option :unassigned
      option :today
      option :overdue
      option :priority
      option :nocategory
      def list
        opts = {}
        opts[:statusId] = [1, 2, 3] unless options[:all]
        opts[:assigneeId] = [-1] if options[:unassigned]
        if options[:today]
          today = Date.today
          opts[:dueDateSince] = today.to_s
          opts[:dueDateUntil] = today.next.to_s
        end
        opts[:dueDateUntil] = Date.today.to_s if options[:overdue]
        if options[:priority]
          opts[:sort] = 'priority'
          opts[:order] = 'asc'
        end
        opts[:categoryId] = [-1] if options[:nocategory]
        opts[:count] = ISSUES_COUNT_MAX
        res = request(:get, 'issues', opts)
        print_response(res, :issue)
      end

      desc 'update [KEY...]', 'update issues'
      options ISSUE_BASE_ATTRIBUTES
      option :comment, type: :string
      def update(*keys)
        keys.each do |k|
          res = request(:patch, "issues/#{k}", delete_class_options(options.to_h))
          puts 'issue updated'
          print_response(res, :issue)
        end
      end

      desc 'search', 'search issues'
      options ISSUES_PARAMS
      def search
        res = request(:get, 'issues', delete_class_options(options.to_h))
        print_response(res, :issue)
      end

    end
  end
end
