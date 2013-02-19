#!/usr/bin/env rspec

require 'spec_helper'
require File.join(File.dirname(__FILE__), '../../', 'facts', 'facter_facts.rb')

module MCollective
  module Facts
    describe Facter_facts do
      module Facter; end

      let(:config) { mock }

      before do
        Facter_facts.any_instance.stubs('require')
        Config.stubs(:instance).returns(config)
        @facts = Facter_facts.new
        Log.stubs(:debug)
        Log.stubs(:info)
        Facter.stubs(:reset)
        Facter.stubs(:to_hash).returns({})
        config.stubs(:pluginconf).returns({})
      end

      describe '#load_facts_from_source' do
        it 'should load facter lib from config' do
          config.expects(:pluginconf).returns({'facter.facterlib' => '/var/lib/rspec'})
          @facts.load_facts_from_source
          ENV['FACTERLIB'].should == '/var/lib/rspec'
        end

        it 'should load the default facter lib' do
          @facts.load_facts_from_source
          ENV['FACTERLIB'].should == '/var/lib/puppet/lib/facter:/var/lib/puppet/facts'
        end

        it 'should return a facts hash' do
          Facter.expects(:reset)
          Facter.expects(:to_hash).returns({'fact_1' => 'x', 'fact_2' => 'y'})
          result = @facts.load_facts_from_source
          result.should == {'fact_1' => 'x', 'fact_2' => 'y'}
        end

        it 'should log a descriptive error message if facter library is missing' do
          @facts.expects(:require).with('facter').raises(LoadError)
          expect{
            @facts.load_facts_from_source
          }.to raise_error LoadError, 'Could not load facts from fact source. Missing fact library: facter'
        end
      end
    end
  end
end
