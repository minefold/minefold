# Renames "unlimited" Users to "beta"

Pivot.db[:users].update(
  {},
  {'$rename' => {'unlimited' => 'beta'}},
  {multi: true, safe: true}
)
