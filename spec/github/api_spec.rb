require 'capistrano/github/api'

RSpec.describe Capistrano::Github::API do
  subject(:api) { described_class.new(repo_url, access_token) }

  let(:access_token) { 'some-token' }
  let(:repo_url) { 'git@github.com:3scale/capistrano-github.git' }

  context 'invalid repo url' do
    let(:repo_url) { 'some-invalid' }

    it do
      expect{ subject }.to raise_error(Capistrano::Github::API::InvalidRepoUrl)
    end
  end

  context 'missing repo url' do
    let(:repo_url) { nil }

    it do
      expect{ subject }.to raise_error(Capistrano::Github::API::InvalidRepoUrl)
    end
  end

  context 'missing access token' do
    let(:access_token) { nil }

    it do
      expect{ subject }.to raise_error(Capistrano::Github::API::MissingAccessToken)
    end
  end
end
