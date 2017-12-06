module Bl
  module Commands
    class Recent < Command
      def initialize(*)
        @config = Bl::Config.instance
        super
      end

      desc 'issues COUNT', 'list recently viewed issues'
      def issues(count = nil)
        res = request(:get, 'users/myself/recentlyViewedIssues', count: count)
        res.body.each do |i|
          # TODO: print as table
          puts [i.issue.issueKey, i.issue.summary].join("\t")
        end
      end

      desc 'wikis COUNT', 'list recently viewed wikis'
      def wikis(count = nil)
        res = request(:get, 'users/myself/recentlyViewedWikis', count: count)
        res.body.each do |w|
          # TODO: print as table
          puts [w.page.id, w.page.name].join("\t")
        end
      end
    end
  end
end
