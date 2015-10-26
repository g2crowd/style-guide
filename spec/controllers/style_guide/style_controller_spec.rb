require 'spec_helper'

describe StyleGuide::StyleController, type: :controller do
  routes { StyleGuide::Engine.routes }

  let(:temp_path) { Dir.mktmpdir }
  let(:partial_path) { File.join(temp_path, 'monkey_hammer') }

  before do
    FileUtils.mkdir_p(partial_path)
    StyleGuide::Engine.config.style_guide.paths = "#{temp_path}/*"
  end

  describe '#index' do
    it 'assigns sections' do
      get :index
      expect(assigns(:sections)).not_to be_nil
      expect(assigns(:sections).size).to eq 1
      expect(assigns(:sections).first).to be_a StyleGuide::Section
    end

    it 'sets the current section to the first one' do
      get :index
      expect(assigns(:current_section)).to eq assigns(:sections).first
      expect(assigns(:current_section).title).to eq 'Monkey Hammer'
    end
  end

  describe '#show' do
    it 'assigns sections' do
      get :show, id: 'monkey_hammer'
      expect(assigns(:sections)).not_to be_nil
      expect(assigns(:sections).size).to eq 1
      expect(assigns(:sections).first).to be_a StyleGuide::Section
    end

    it 'assigns the section' do
      get :show, id: 'monkey_hammer'
      expect(assigns(:current_section)).to be_a StyleGuide::Section
      expect(assigns(:current_section).title).to eq 'Monkey Hammer'
    end
  end
end
