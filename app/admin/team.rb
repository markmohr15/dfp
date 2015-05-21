ActiveAdmin.register Team do

  index do
    column :name
    actions
  end

  show do
    panel "Lineup" do
      table_for team.batters do
        column "Batters" do |batter|
          batter.name
        end
        column :lineup_spot
      end
    end

    panel "Pitchers" do
      table_for team.pitchers do
        column "Pitchers" do |pitcher|
          pitcher.name
        end
        column :reliever
      end
    end
  end

  form do |f|
    f.semantic_errors *f.object.errors.keys
    f.inputs "Team" do
      f.input :name
    end
    f.inputs do
      f.has_many :batters do |c|
        c.input :name
        c.input :lineup_spot
      end
    end
    f.inputs do
      f.has_many :pitchers do |c|
        c.input :name
        c.input :reliever
      end
    end
    f.actions
  end

  permit_params :name, batters_attributes: [:id, :name, :lineup_spot], pitchers_attributes: [:id, :name, :reliever]



end
