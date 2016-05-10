module Bl
  class Recent < Thor
    include Bl::Requestable

    def initialize(*)
      @config = Bl::Config.instance
      super
    end

    desc 'issue COUNT', 'list recent issues'
    def issue(count=nil)
      client.get('users/myself/recentlyViewedIssues', count: count).body.each do |i|
        puts [i.issue.issueKey, i.issue.summary].join("\t")
      end
    end
  end
end
