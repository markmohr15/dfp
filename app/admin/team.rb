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
    f.actions
  end

  permit_params :name, batters_attributes: [:id, :name, :lineup_spot]



end
