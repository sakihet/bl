module Bl
  class GitRepo < Command

    def initialize(*)
      @config = Bl::Config.instance
      @url = "projects/#{@config[:project_key]}/git/repositories"
      super
    end

    desc 'list', 'list git repositories'
    def list
      res = client.get(@url)
      print_response(res)
    end

    desc 'show ID', 'show a git repository'
    def show(id)
      res = client.get("#{@url}/#{id}")
      puts formatter.render(res.body, fields: GIT_REPO_FIELDS, vertical: true)
    end

    private

    def print_response(res)
      puts formatter.render(res.body, fields: GIT_REPO_FIELDS)
    end
  end
end
