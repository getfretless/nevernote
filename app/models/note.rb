class Note < ActiveRecord::Base
  belongs_to :user
  validates :title, presence: true, length: { maximum: 200 }
  default_scope { order('updated_at DESC') }
  scope :ordered, -> { order('created_at DESC') }
  before_save :sanitize_body

  private

  def sanitize_body
    self.body_html = Sanitize.fragment body_html, Sanitize::Config::RELAXED
    self.body_text = Sanitize.clean body_html.strip
  end
end
