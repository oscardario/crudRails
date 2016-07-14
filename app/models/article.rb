class Article < ActiveRecord::Base
  belongs_to :user
  has_many :comments
  has_attached_file :cover, styles: { medium: "1280x720", thumb: "800x600"}
  validates_attachment_content_type :cover, content_type: /\Aimage\/.*\Z/  #permitir solo imagenes
  validates :title, :presence => {:message => "El titulo es obligatorio"}
  validates :body, :presence => {:message => "La descripcion es obligatoria"}
#   #Validaciones de nombre
#  validates :nombre, :presence => {:message => "Usted debe ingresar un nombre"}, length: {minimum: 2, maximum: 50, :message => "El nombre debe tener entre 2 y 50 caracteres"}
#  #Validaciones de apellido
#  validates :apellido, :presence => {:message => "Usted debe ingresar un apellido"}, length: {minimum: 2, maximum: 50, :message => "El apellido debe tener entre 2 y 50 caracteres"}
#  #Validaciones de legajo
#  validates :legajo, :presence => {:message => "Usted debe ingresar un legajo"}, :numericality => {:only_integer => true, :message => "El legajo debe ser numérica"}, :uniqueness => {:message => "Usted ha ingresado un legajo repetido"}
  before_save :set_vists_count

  def update_visits_count
    self.update(visits_count: self.visits_count + 1)
  end
  private

  def set_vists_count
    self.visits_count ||= 0
  end
end
