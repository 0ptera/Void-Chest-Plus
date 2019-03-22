for i, force in pairs(game.forces) do
  if force.technologies["advanced-material-processing"].researched then
    force.recipes["void-chest"].enabled = true
  else
    force.recipes["void-chest"].enabled = false
  end
end
