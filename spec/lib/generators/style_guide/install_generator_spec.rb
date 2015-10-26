require 'spec_helper'

describe StyleGuide::InstallGenerator do
  describe '#install' do
    before do
      %i(gem route bundle_command application).each do |method|
        allow(subject).to receive(method)
      end

      allow(Rack).to receive(:const_get).and_return('constant')
      allow(Guard).to receive(:const_get).and_return('constant')

      allow(subject).to receive(:routes_rb).and_return('mount StyleGuide::Engine')
      allow(subject).to receive(:guardfile).and_return("guard 'livereload'")
      allow(subject).to receive(:application_rb).and_return('config.style_guide.paths')
      allow(subject).to receive(:development_rb).and_return('Rack::LiveReload')
    end

    describe 'rack livereload dependency' do
      context 'when rack-livereload is installed' do
        it 'does not add rack-livereload to the Gemfile' do
          expect(subject).not_to receive(:gem).with('rack-livereload', anything)
          subject.install
        end
      end

      context 'when rack-livereload is not installed' do
        before { allow(Rack).to receive(:const_get).and_raise(NameError) }

        it 'adds rack-livereload to the Gemfile' do
          expect(subject).to receive(:gem).with('rack-livereload', anything)
          subject.install
        end

        it 'runs bundle install' do
          expect(subject).to receive(:bundle_command).with('install')
          subject.install
        end
      end
    end

    describe 'guard livereload dependency' do
      context 'when guard-livereload is installed' do
        it 'does not add guard-livereload to the Gemfile' do
          expect(subject).not_to receive(:gem).with('guard-livereload', anything)
          subject.install
        end
      end

      context 'when guard-livereload is not installed' do
        before { allow(Guard).to receive(:const_get).and_raise(NameError) }

        it 'adds guard-livereload to the Gemfile' do
          expect(subject).to receive(:gem).with('guard-livereload', anything)
          subject.install
        end

        it 'runs bundle install' do
          expect(subject).to receive(:bundle_command).with('install')
          subject.install
        end
      end
    end

    describe 'guard livereload configuration' do
      context 'when guard-livereload is in the Guardfile' do
        it 'does not add guard-livereload to the Guardfile' do
          expect(subject).not_to receive(:bundle_command)
          subject.install
        end
      end

      context 'when guard-livereload is not in the Guardfile' do
        before { allow(subject).to receive(:guardfile).and_return('meat') }

        it 'adds guard-livereload to the Guardfile' do
          expect(subject).to receive(:bundle_command).with('exec guard init livereload')
          subject.install
        end
      end
    end

    describe 'rails configuration' do
      context 'when style guide is not configured in application.rb' do
        before { allow(subject).to receive(:application_rb).and_return('') }

        it 'adds an entry for style guide partial paths' do
          expect(subject).to receive(:application).once do |config, options|
            expect(options).to be_nil
            expect(config).to include 'config.style_guide.paths'
            expect(config).to include subject.default_partial_path
          end
          subject.install
        end
      end

      context 'when style guide is configured in application.rb' do
        before { allow(subject).to receive(:application_rb).and_return('config.style_guide.paths') }

        it 'does not modify application.rb' do
          expect(subject).not_to receive(:application)
          subject.install
        end
      end
    end

    describe 'development configuration' do
      context 'when livereload is not configured in development.rb' do
        before { allow(subject).to receive(:development_rb).and_return('') }

        it 'adds an entry for livereload' do
          expect(subject).to receive(:application).once do |config, options|
            expect(options).to eq(env: 'development')
            expect(config).to include 'config.middleware.insert_before'
            expect(config).to include 'Rack::LiveReload'
          end
          subject.install
        end
      end

      context 'when livereload is already configured in development.rb' do
        before { allow(subject).to receive(:development_rb).and_return('Rack::LiveReload') }

        it 'does not modify development.rb' do
          expect(subject).not_to receive(:application)
          subject.install
        end
      end
    end

    describe 'mounting' do
      context 'when style guide is not mounted' do
        before { allow(subject).to receive(:routes_rb).and_return('') }

        it 'mounts the style guide' do
          expect(subject).to receive(:route).with('mount StyleGuide::Engine => "/style-guide"')
          subject.install
        end
      end

      context 'when style guide is not mounted' do
        before { allow(subject).to receive(:routes_rb).and_return('mount StyleGuide::Engine') }

        it 'does not mount the style guide' do
          expect(subject).not_to receive(:route)
          subject.install
        end
      end
    end
  end
end
