# Capistrano::Github

In January 2014 Github Team [accounced Deployments API](http://developer.github.com/changes/2014-01-09-preview-the-new-deployments-api/) and you can use it with Capistrano 3.

## Installation

Add this line to your application's Gemfile:

    gem 'capistrano-github'
    gem 'octokit', github: 'octokit/octokit.rb', branch: 'deployments-preview'

And then execute:

    $ bundle


Declare `github_access_token` and require integration tasks:

```ruby
# Capfile
require 'capistrano/github'
```

```ruby
# deploy.rb
set :github_access_token, '89c3be3d1f917b6ccf5e2c141dbc403f57bc140c'
```

You can obtain your personal GH token [here](https://github.com/settings/applications)

## Usage

```bash
cap production github:deployments
```

New deployment record will be created automatically on each `cap deploy` run.

## Contributing

1. Fork it ( http://github.com/<my-github-username>/capistrano-github/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
