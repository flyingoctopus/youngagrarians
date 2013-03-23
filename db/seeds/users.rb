def seed_users
  puts 'Seeding users'

  # ---------------------------------------------------------------------

  u = User.create(
    :username       => 'vincent',
    :first_name     => 'Vincent',
    :last_name      => 'van Haaff',
    :usename        => 'vincent',
    :email          => 'vincent@vanhaaff.com',
    :password       => 'test42',
  )

  # ---------------------------------------------------------------------

  u = User.create(
    :username       => 'sean',
    :first_name     => 'Sean',
    :last_name      => 'Hagen',
    :usename        => 'sean',
    :email          => 'sean.hagen@gmail.com',
    :password       => 'test42',
  )

  # ---------------------------------------------------------------------

  u = User.create(
    :username       => 'sara',
    :first_name     => 'Sara',
    :last_name      => 'Dent',
    :email          => 'dentsara@gmail.com',
    :password       => 'test42',
  )
end
