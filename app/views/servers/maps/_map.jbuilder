json.(map,
  :id,
  :server_id,
  :host,
  :zoom_levels,
  :tile_size,
  :last_mapped_at,
  :created_at,
  :updated_at
)

json.spawn do
  if spawn = map.map_data['spawn']
    json.x spawn['x']
    json.y spawn['y']
    json.z spawn['z']
  else
    json.x 0
    json.y 0
    json.z 0
  end
end
