# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

# userSeeder
# admin

first_admin = User.create!(name: 'Wladimir Souza',email: 'admin@leilaodogalpao.com.br', password: 'password',
            sex:1, role: :admin, cpf: '491.150.798.55')

second_admin = User.create!(name: 'João Silva',email: 'joao_cc@leilaodogalpao.com.br', password: 'password',
  sex:1, role: :admin, cpf: '111.222.333.44')


first_user = User.create!(name: 'José Silva',email: 'user@gmail.com', password: 'password',
            sex:1, role: :user, cpf: '491.150.798.20')

second_user = first_user = User.create!(name: 'José Silva',email: 'user_2@gmail.com', password: 'password',
            sex:1, role: :user, cpf: '491.150.798.10')


# categorySeeder

Category.create!(name: 'Celulares')
Category.create!(name: 'Televisões')
Category.create!(name: 'Video Games')
Category.create!(name: 'Eletrônicos')


# lotSeeder

first_lot = Lot.create!(code: 'ABC123', start_date: '2021-05-01 10:15:00', end_date: '2023-05-30 15:30:00',
          minimum_value: 100, minimum_difference: 10,
          created_by: first_admin, approved_by: second_admin)

second_lot = Lot.create!(code: 'ABC111', start_date: '2021-05-01 10:15:00', end_date: '2023-05-30 15:30:00',
            minimum_value: 200, minimum_difference: 10,
            created_by: second_admin, approved_by: first_admin)


third_lot = Lot.create!(code: 'ABC999', start_date: 1.day.from_now, end_date: 5.days.from_now,
              minimum_value: 300, minimum_difference: 50,
              created_by: second_admin)

fourth_lot = Lot.create!(code: 'ZAZ123', start_date: '2021-05-01 10:15:00', end_date: 50.seconds.from_now,
                minimum_value: 100, minimum_difference: 10,
                created_by: second_admin, approved_by: first_admin)

fifith_lot = Lot.create!(code: 'ZZZ111', start_date: '2021-05-01 10:15:00', end_date: 5.seconds.from_now,
                  minimum_value: 250, minimum_difference: 30,
                  created_by: second_admin)



# itemSeeder


# Carregando imagens
caneca_botafogo_image = { io: File.open(Rails.root.join('db/seeds_images/caneca-botafogo.jpg')), filename: 'caneca-botafogo.jpg', content_type: 'image/jpg' }
caneca_vasco_image = { io: File.open(Rails.root.join('db/seeds_images/caneca-vasco.png')), filename: 'caneca-vasco.png', content_type: 'image/jpg' }
iphone_image = { io: File.open(Rails.root.join('db/seeds_images/iphonexs.png')), filename: 'iphonexs.png', content_type: 'image/jpg' }
s20_image = { io: File.open(Rails.root.join('db/seeds_images/s20.jpg')), filename: 's20.jpg', content_type: 'image/jpg' }
tvsamsung_image = { io: File.open(Rails.root.join('db/seeds_images/tvsamsung.jpg')), filename: 'tvsamsung.jpg', content_type: 'image/jpg' }
motoyamaha_image = { io: File.open(Rails.root.join('db/seeds_images/moto-leilao.png')), filename: 'moto-leilao.png', content_type: 'image/png' }
gol_gw = { io: File.open(Rails.root.join('db/seeds_images/gol-gts.jpg')), filename: 'gol-gts.jpg', content_type: 'image/jpg' }
gol_gw2 = { io: File.open(Rails.root.join('db/seeds_images/gol-gts.jpg')), filename: 'gol-gts.jpg', content_type: 'image/jpg' }

# Criando itens
first_item = Item.create!(
  name: 'Caneca Botafogo',
  description: 'Caneca temática do Botafogo, perfeita para mostrar o seu amor pelo time enquanto desfruta de uma bebida quente. Fabricada em cerâmica de alta qualidade e com capacidade para 300ml, é ideal para uso diário ou para presentear um torcedor apaixonado. Aproveite seu café ou chá com muito estilo!',
  photo: caneca_botafogo_image, weight: 300, width: 8, height: 10, depth: 8, user_id: first_admin.id)

second_item = Item.create!(
  name: 'Caneca Vasco',
  description: 'Caneca temática do Vasco, ideal para os torcedores do clube cruzmaltino. Feita em cerâmica resistente, possui capacidade para 350ml e conta com estampa exclusiva do time. Seja para usar em casa, no trabalho ou presentear alguém especial, essa caneca é uma ótima escolha para os vascaínos de coração!',
  photo: caneca_vasco_image, weight: 320, width: 8, height: 10, depth: 8, user_id: first_admin.id)

third_item = Item.create!(
  name: 'iPhone XS',
  description: 'O iPhone XS é um dos modelos mais avançados da Apple. Equipado com o poderoso processador A12 Bionic, oferece desempenho excepcional e recursos inovadores. Com uma tela OLED Super Retina de 5,8 polegadas, proporciona imagens vibrantes e detalhadas. Capture fotos incríveis com a câmera de alta resolução e aproveite todos os recursos e aplicativos disponíveis no ecossistema da Apple.',
  photo: iphone_image, weight: 194, width: 7, height: 14, depth: 0.8, user_id: first_admin.id)

fourth_item = Item.create!(
  name: 'Samsung S20',
  description: 'O Samsung Galaxy S20 é um smartphone poderoso que oferece desempenho excepcional e recursos avançados. Com uma tela AMOLED de alta resolução e taxa deatualização suave de 120Hz, proporciona uma experiência visual imersiva. Com uma câmera de alta resolução, você pode capturar fotos nítidas e vídeos em 8K. Além disso, o S20 oferece recursos avançados, como reconhecimento facial, carregamento sem fio e resistência à água e poeira.',
  photo: s20_image, weight: 163, width: 6, height: 15, depth: 0.7, user_id: first_admin.id)
  
fifth_item = Item.create!(
  name: 'TV Samsung',
  description: 'A TV Samsung é uma televisão de alta definição que proporciona uma experiência de entretenimento incrível. Com uma tela grande e tecnologia avançada, você pode desfrutar de imagens nítidas e cores vibrantes. Aproveite seus filmes, programas de TV e jogos favoritos com qualidade de imagem excepcional. Além disso, a TV Samsung possui recursos inteligentes que permitem acessar conteúdos online e conectar-se a outros dispositivos.',
  photo: tvsamsung_image, weight: 12000, width: 120, height: 70, depth: 10, user_id: first_admin.id)

sixth_item = Item.create!(
  name: 'YAMAHA YBR150 FACTOR ED 19/20',
  description: 'Bem encontra-se: Rod. Anhanguera, Km 306,5 - Ribeirão Preto/SP - Veiculounico Dono. CRLV-e será entregue junto com o veiculo. Documentação para transferência (ATPV-e) em até 20 dias úteis. IPVA 2023 PAGO, porém se por ventura surgir algum residuo inclusive dos anos anteriores serão de inteira responsabilidade e encargos do comprador. Transferência, dpvat se houver e LICENCIAMENTO serão de responsabilidade e encargos do comprador.(1) O veículo será vendido no estado em que se encontra, sem garantias quanto à problemas mecanicos e eletrica mesmo de forma oculta, estrutura em suas características estruturais, reparos, reposições de peças ou substituições. (2) Os veículos encontram-se à disposição para que os arrematantes, previamente ao leilão, efetuem todas as vistorias necessárias no bem a ser adquirido, de forma que o comitente vendedor não aceitará reclamações posteriores à venda. (3) Multas que possam aparecer após a transferência com data da origem até a data do leilão serão de encargos e resposnabilidade do vendedor.',
  photo: motoyamaha_image, weight: 12000, width: 120, height: 70, depth: 10, user_id: first_admin.id)

seventh_item = Item.create!(
    name: 'VW GOL GTS',
    description: 'VW GOL GTS PLACA KCG0165 SEBASTIANOPOLIS DO SUL - ANO 87/87 - COR CINZA - COMB ALCOOL - CHASSI 9BWZZZ30ZHT066498 - MOTOR UE182622 - RENAVAN 112936709 - SUCATA SEM DIREITO A DOCUMENTO - MELHOR CARRO JÁ FEITO NO BRASIL.',
    photo: gol_gw, weight: 12000, width: 120, height: 70, depth: 10, user_id: first_admin.id)

eight_item = Item.create!(
    name: 'GOL TURBO',
    description: 'VW GOL GTS PLACA KCG0165 SEBASTIANOPOLIS DO SUL - ANO 87/87 - COR CINZA - COMB ALCOOL - CHASSI 9BWZZZ30ZHT066498 - MOTOR UE182622 - RENAVAN 112936709 - SUCATA SEM DIREITO A DOCUMENTO - MELHOR CARRO JÁ FEITO NO BRASIL.',
    photo: gol_gw2, weight: 12000, width: 120, height: 70, depth: 10, user_id: first_admin.id)
  
ItemLot.create!(item_id: first_item.id, lot_id: first_lot.id)
ItemLot.create!(item_id: second_item.id, lot_id: first_lot.id)
ItemLot.create!(item_id: third_item.id, lot_id: first_lot.id)
ItemLot.create!(item_id: fourth_item.id, lot_id: second_lot.id)
ItemLot.create!(item_id: fifth_item.id, lot_id: second_lot.id)
ItemLot.create!(item_id: sixth_item.id, lot_id: fourth_lot.id)
ItemLot.create!(item_id: seventh_item.id, lot_id: fourth_lot.id)
ItemLot.create!(item_id: eight_item.id, lot_id: fifith_lot.id)

Bid.create!(user_id: second_user.id, lot_id: fourth_lot.id, value: 300)