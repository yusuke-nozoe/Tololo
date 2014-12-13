# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

# List の作成
todo  = List.create(:name => "Todo")
doing = List.create(:name => "Doing")
done  = List.create(:name => "Done")

# Cardのシードデータ
%w{ラーメン屋にいく もやしを食べる 注文する ラーメンを食べる 替え玉を食べる お会計を支払う}.each do |task|
  Card.create(:list_id => todo.id, :content => task)
end
