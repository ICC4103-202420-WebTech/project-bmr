# db/seeds.rb

# Crear usuarios
users_data = [
  { email: "john.wick@example.com", password: "contraseña", role: "teacher", first_name: "John", last_name: "Wick" },
  { email: "el.pepe@example.com", password: "contraseña", role: "teacher", first_name: "El", last_name: "Pepe" },
  { email: "papa.johns@example.com", password: "contraseña", role: "teacher", first_name: "Papa", last_name: "Johns" },
  { email: "roelckers@example.com", password: "contraseña", role: "student", first_name: "Raimundo", last_name: "Oelckers" },
  { email: "ada.lovelace@example.com", password: "contraseña", role: "student", first_name: "Ada", last_name: "Lovelace" },
  { email: "alan.turing@example.com", password: "contraseña", role: "student", first_name: "Alan", last_name: "Turing" },
  { email: "grace.hopper@example.com", password: "contraseña", role: "student", first_name: "Grace", last_name: "Hopper" },
  { email: "margaret.hamilton@example.com", password: "contraseña", role: "student", first_name: "Margaret", last_name: "Hamilton" },
]

users_data.each do |user_data|
  User.find_or_create_by!(email: user_data[:email]) do |user|
    user.password = user_data[:password]
    user.role = user_data[:role]
    user.first_name = user_data[:first_name]
    user.last_name = user_data[:last_name]
  end
end

puts "Usuarios creados exitosamente!"

# Crear un curso completo con detalles
teacher = User.find_by(email: "john.wick@example.com", role: "teacher")
if teacher.nil?
  puts "Error: Profesor no encontrado. Seed abortado."
  exit
end

course = Course.find_or_create_by!(title: "Curso Completo de Ruby on Rails", teacher_id: teacher.id) do |c|
  c.description = "Un curso completo para aprender Ruby on Rails desde cero hasta avanzado."
end

puts "Curso creado exitosamente: #{course.title}"

# Inscribir a todos los estudiantes en el curso
students = User.where(role: "student")
students.each do |student|
  Enrollment.find_or_create_by!(user_id: student.id, course_id: course.id) do |enrollment|
    enrollment.progress = 10 # Asumen que completaron la lección de introducción
  end
end

puts "Estudiantes inscritos exitosamente al curso: #{course.title}"

# Crear lecciones detalladas con preguntas y comentarios
lessons_data = [
  {
    title: "Bienvenida",
    content: "¡Bienvenidos al curso! En esta lección, exploraremos los objetivos del curso y cómo puedes aprovecharlo al máximo.\n\n" \
             "Este curso está diseñado para guiarte desde lo básico de Ruby on Rails hasta temas más avanzados. \n\n" \
             "¿Listo para comenzar? Haz clic en la siguiente lección cuando estés preparado.",
    questions: [
      { content: "¿Cómo aprovechar mejor este curso?", asker_email: "ada.lovelace@example.com", answers: [{ content: "Participa activamente en las preguntas y sigue las guías paso a paso.", responder_email: "john.wick@example.com" }] },
    ],
  },
  {
    title: "Instalación y configuración",
    content: "Para comenzar con Ruby on Rails, necesitas instalar algunas herramientas fundamentales:\n\n" \
             "1. **Ruby**: Instálalo desde [ruby-lang.org](https://www.ruby-lang.org/en/downloads/).\n" \
             "2. **Rails**: Usa el siguiente comando una vez tengas Ruby: `gem install rails`.\n" \
             "3. **PostgreSQL**: Descarga e instala PostgreSQL desde [postgresql.org](https://www.postgresql.org/).\n\n" \
             "Una vez instalado, verifica las versiones con:\n" \
             "```bash\nruby --version\nrails --version\npsql --version\n```\n\n" \
             "Asegúrate de que todo esté correctamente configurado antes de proceder.",
    questions: [
      { content: "¿Qué pasa si PostgreSQL no funciona?", asker_email: "roelckers@example.com", answers: [{ content: "Verifica las configuraciones en el archivo pg_hba.conf.", responder_email: "john.wick@example.com" }] },
    ],
  },
  {
    title: "Entendiendo MVC",
    content: "Ruby on Rails sigue el patrón Modelo-Vista-Controlador (MVC):\n\n" \
             "- **Modelo**: Maneja los datos y la lógica de negocios.\n" \
             "- **Vista**: Define cómo se presenta la información al usuario.\n" \
             "- **Controlador**: Conecta modelos y vistas, manejando la lógica de la aplicación.\n\n" \
             "Por ejemplo, cuando un usuario solicita una página, el controlador procesa la solicitud, interactúa con el modelo y selecciona la vista adecuada para mostrar.",
    questions: [],
  },
  {
    title: "Modelos en Rails",
    content: "Los modelos en Rails representan los datos y la lógica de negocios.\n\n" \
             "Por ejemplo, para un sistema de cursos, podrías tener un modelo `Course` que define:\n\n" \
             "- **Atributos**: Título, descripción, etc.\n" \
             "- **Relaciones**: `has_many :lessons`, `belongs_to :teacher`.\n\n" \
             "Los modelos se crean con el comando:\n" \
             "```bash\nrails generate model ModelName\n```\n\n" \
             "Luego, puedes definir validaciones y asociaciones en el archivo del modelo.",
    questions: [],
  },
  {
    title: "Bases de datos con ActiveRecord",
    content: "ActiveRecord es la capa de acceso a la base de datos de Rails. Permite interactuar con tablas como si fueran objetos de Ruby.\n\n" \
             "Por ejemplo, para encontrar un curso:\n" \
             "```ruby\nCourse.find(1)\n```\n\n" \
             "Para agregar un curso:\n" \
             "```ruby\nCourse.create(title: 'Nuevo Curso', description: 'Descripción del curso')\n```\n\n" \
             "ActiveRecord también soporta migraciones para modificar esquemas de bases de datos fácilmente.",
    questions: [],
  },
  {
    title: "Controladores y Rutas",
    content: "Los controladores manejan la lógica de la aplicación y se conectan a las rutas definidas en `config/routes.rb`.\n\n" \
             "Por ejemplo, una ruta para mostrar un curso sería:\n" \
             "```ruby\nget '/courses/:id', to: 'courses#show'\n```\n\n" \
             "Esto llama al método `show` en el controlador `CoursesController`, donde puedes definir qué hacer con la solicitud.",
    questions: [],
  },
  {
    title: "Autenticación con Devise",
    content: "Devise es una gema para manejar autenticación de usuarios. Para agregarla, sigue estos pasos:\n\n" \
             "1. Añade `gem 'devise'` en tu Gemfile y corre `bundle install`.\n" \
             "2. Configura Devise:\n" \
             "```bash\nrails generate devise:install\nrails generate devise User\nrails db:migrate\n```\n\n" \
             "Esto creará un modelo `User` con soporte para autenticación.",
    questions: [],
  },
  {
    title: "Conclusión",
    content: "¡Felicidades por completar el curso! Esperamos que hayas aprendido mucho y estés listo para aplicar tus conocimientos.\n\n" \
             "Recuerda practicar y explorar más allá de este curso. ¡Buena suerte!",
    questions: [
      { content: "¡Gracias por este curso tan completo!", asker_email: "ada.lovelace@example.com", answers: [{ content: "¡De nada! Sigue practicando para mejorar.", responder_email: "john.wick@example.com" }] },
      { content: "¡Muy bien explicado, ahora me siento más preparado!", asker_email: "alan.turing@example.com", answers: [] },
      { content: "¡Gran curso, lo recomendaré a mis amigos!", asker_email: "grace.hopper@example.com", answers: [] },
    ],
  },
]

lessons_data.each do |lesson_data|
  lesson = Lesson.find_or_create_by!(title: lesson_data[:title], course_id: course.id) do |l|
    l.content = lesson_data[:content]
    l.lesson_type = "text"
  end

  # Crear preguntas y respuestas
  lesson_data[:questions].each do |question_data|
    asker = User.find_by(email: question_data[:asker_email])
    question = Question.find_or_create_by!(content: question_data[:content], lesson_id: lesson.id, user_id: asker.id)

    question_data[:answers].each do |answer_data|
      responder = User.find_by(email: answer_data[:responder_email])
      Answer.find_or_create_by!(content: answer_data[:content], question_id: question.id, user_id: responder.id)
    end
  end
end

puts "Lecciones, preguntas y respuestas creadas exitosamente para el curso completo."

# Crear otros cursos de ejemplo (sin inscribir estudiantes)
teachers = User.where(role: "teacher").limit(3)
course_titles = [
  "Introducción a LaTeX",
  "Fundamentos de JavaScript",
  "Excel para Finanzas",
  "Diseño UI/UX Básico",
  "Desarrollo Frontend con React",
  "Desarrollo Backend con Node.js",
  "Bases de Datos Relacionales",
  "Aprende Python desde Cero"
]

course_titles.each_with_index do |title, index|
  teacher = teachers[index % teachers.count]
  
  # Crear curso
  course = Course.find_or_create_by!(title: title, teacher_id: teacher.id) do |c|
    c.description = "Descripción básica del curso de #{title}. Aprende los fundamentos y más."
  end
  
  # Crear lecciones aleatorias para el curso
  rand(3..7).times do |lesson_index|
    Lesson.find_or_create_by!(title: "Lección #{lesson_index + 1} del curso #{title}", course_id: course.id) do |lesson|
      lesson.content = "Este es el contenido de la lección #{lesson_index + 1} del curso #{title}. Aquí se explican conceptos básicos y ejemplos para mejorar tu comprensión."
      lesson.lesson_type = "text"
    end
  end
end

puts "Cursos de ejemplo con lecciones creados exitosamente."
