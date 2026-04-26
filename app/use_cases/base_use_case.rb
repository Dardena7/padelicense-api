class BaseUseCase
  def self.run(**args)
    new(**args).run
  end

  def run
    ActiveRecord::Base.transaction do
      call
    end
  end

  private

  def call
    raise NotImplementedError, "#{self.class} must implement #call"
  end
end
