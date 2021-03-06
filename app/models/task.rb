class Task < ActiveRecord::Base

  LEVELS = %w{podstawa rozszerzenie dwujęzyczne}

  belongs_to :exam
  belongs_to :skill
  has_many :subtasks, dependent: :destroy
  has_many :students, through: :subtasks

  accepts_nested_attributes_for :subtasks

  validates_uniqueness_of :number, scope: [:exam_id, :level]

  scope :standard, -> { where level: 'podstawa' }
  scope :extended, -> { where level: 'rozszerzenie' }
  scope :bilingual, -> { where level: 'dwujęzyczne' }
end
