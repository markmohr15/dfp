ActiveAdmin.register Matchup do

  index do
    column :visitor
    column :home
    column :visiting_pitcher
    column :home_pitcher
    column :day
    column :pin_vis_close
    column :pin_home_close
    column "No Vig (home)" do |matchup|
      matchup.no_vig_close
    end
    actions
  end

  show do
    attributes_table do
      row :visitor
      row :home
      row :visiting_pitcher
      row :home_pitcher
      row :day
      row :pin_vis_close
      row :pin_home_close
      row "No Vig (home)" do |matchup|
        matchup.no_vig_close
      end
    end
  end

  form do |f|
    f.semantic_errors *f.object.errors.keys
    f.inputs "Matchups" do
      f.input :visitor
      f.input :home
      f.input :visiting_pitcher, as: :select, collection: Pitcher.where(team_id: matchup.visitor_id)
      f.input :home_pitcher, as: :select, collection: Pitcher.where(team_id: matchup.home_id)
      f.input :day
    end
    f.actions
  end

  permit_params :visitor_id, :home_id, :visiting_pitcher_id, :home_pitcher_id, :day

end
