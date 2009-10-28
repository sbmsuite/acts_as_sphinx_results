# ActsAsSphinxResults
module ActsAsSphinxResults
  def self.included(base)
    base.extend(ClassMethods)
  end

  class Config
    attr_reader :model

    def initialize(model_id)
      @model_id = model_id
      @model = model_id.to_s.camelize.constantize
    end
    
    def model_name
      @model_id.to_s
    end
  end

  module ClassMethods
    def acts_as_sphinx_results(model_id = nil)
      model_id = self.to_s.split('::').last.sub(/Controller$/, '').pluralize.singularize.underscore unless model_id
      @acts_as_sphinx_results_config = ActsAsSphinxResults::Config.new(model_id)
      include ActsAsSphinxResults::InstanceMethods
    end

    def acts_as_sphinx_results_config
      @acts_as_sphinx_results_config || self.superclass.instance_variable_get('@acts_as_sphinx_results_config')
    end
  end

  module InstanceMethods
    def search_records
      @results = self.class.acts_as_sphinx_results_config.model.search(params[:keyword], :page => params[:page], :per_page => 30)
      render :action => :search_records_results
    end
  end
end
