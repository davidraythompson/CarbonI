using CarbonI, Plots

geos = CarbonI.loadGeos("src/GeosChem/GeosChem.yaml")
aod_salc = geos.data["aod_salc"];
aod_sala = geos.data["aod_sala"];
aod_ocpi = geos.data["aod_ocpi"];
aod_bcpi = geos.data["aod_bcpi"];
aod_so4 = geos.data["aod_so4"];
aod_strat = geos.data["aod_strat"];

heatmap(sum(aod_so4[:,:,:,1], dims=3)[:,:,1]',color=:viridis); title!("AOD_SO4");savefig("/home/cfranken/AOD_SO4.pdf")
heatmap(sum(aod_sala[:,:,:,1], dims=3)[:,:,1]',color=:viridis); title!("AOD_SAL Accumlation mode");savefig("/home/cfranken/AOD_SALA.pdf")
heatmap(sum(aod_salc[:,:,:,1], dims=3)[:,:,1]',color=:viridis); title!("AOD_SAL Coarse mode");savefig("/home/cfranken/AOD_SALC.pdf")
heatmap(sum(aod_ocpi[:,:,:,1], dims=3)[:,:,1]',color=:viridis); title!("AOD_OCPI");savefig("/home/cfranken/AOD_OCPI.pdf")
heatmap(sum(aod_bcpi[:,:,:,1], dims=3)[:,:,1]',color=:viridis);title!("AOD_BCPI");savefig("/home/cfranken/AOD_BCPI.pdf")
heatmap(sum(aod_strat[:,:,:,1], dims=3)[:,:,1]',color=:viridis);title!("AOD Stratosphere (550nm)");savefig("/home/cfranken/AODstrat.pdf")

dp = CarbonI.computeColumnAveragingOperator(geos)

c2h6 = geos.data["c2h6"];
xc2h6 = CarbonI.getColumnAverage(c2h6, dp)

using CarbonI, Plots

lat = 27.2
lon = 82.5

iLat = argmin(abs.(geos.data["lat"] .- lat))
iLon = argmin(abs.(geos.data["lon"] .- lon))
iTime = 1

FT = Float32
# Test profile extractionH2O,CO2,CH4, N2O, CO
q, T, p, p_full, new_vmr = CarbonI.get_profiles_from_geoschem(geos, iLon, iLat, iTime, ["H2O", "CO2", "CH4", "N2O","CO", "C2H6"])
aod = CarbonI.get_aerosols_from_geoschem(geos, iLon, iLat, iTime, ["aod_ocpi", "aod_so4", "aod_strat", "aod_dust"])

p_full, p_half, vmr_h2o, vcd_dry, vcd_h2o, new_vmr2, Δz = CarbonI.compute_atmos_profile_fields(T,convert.(FT,p),q,new_vmr)

plot(aod["aod_so4"], p_full, yflip=true, label="Sulfate Aerosols")
plot!(aod["aod_ocpi"], p_full, yflip=true, label="Organic Carbon Aerosols")
plot!(aod["aod_strat"], p_full, yflip=true, label="Stratospheric Aerosols")
plot!(aod["aod_dust"], p_full, yflip=true, label="Dust Aerosols")