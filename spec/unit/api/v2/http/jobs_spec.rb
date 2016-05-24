require 'spec_helper'

describe Travis::Api::V2::Http::Jobs do
  include Travis::Testing::Stubs, Support::Formats

  let(:data) { Travis::Api::V2::Http::Jobs.new([test]).data }

  it 'jobs' do
    data['jobs'].first.should == {
      'id' => 1,
      'repository_id' => 1,
      'repository_slug' => 'svenfuchs/minimal',
      'build_id' => 1,
      'commit_id' => 1,
      'log_id' => 1,
      'number' => '2.1',
      'state' => 'passed',
      'started_at' => json_format_time(Time.now.utc - 1.minute),
      'finished_at' => json_format_time(Time.now.utc),
      'config' => { 'rvm' => '1.8.7', 'gemfile' => 'test/Gemfile.rails-2.3.x' },
      'queue' => 'builds.linux',
      'allow_failure' => false,
      'tags' => 'tag-a,tag-b'
    }
  end

  it 'commits' do
    data['commits'].first.should == {
      'id' => 1,
      'sha' => '62aae5f70ceee39123ef',
      'branch' => 'master',
      'message' => 'the commit message',
      'committed_at' => json_format_time(Time.now.utc - 1.hour),
      'committer_name' => 'Sven Fuchs',
      'committer_email' => 'svenfuchs@artweb-design.de',
      'author_name' => 'Sven Fuchs',
      'author_email' => 'svenfuchs@artweb-design.de',
      'compare_url' => 'https://github.com/svenfuchs/minimal/compare/master...develop',
    }
  end
end

describe 'Travis::Api::V2::Http::Jobs using Travis::Services::Jobs::FindAll' do
  let(:jobs) { Travis.run_service(:find_jobs, nil) }
  let(:data) { Travis::Api::V2::Http::Jobs.new(jobs).data }

  before :each do
    3.times { Factory(:test) }
  end

  it 'queries' do
    lambda { data }.should issue_queries(4)
  end
end

