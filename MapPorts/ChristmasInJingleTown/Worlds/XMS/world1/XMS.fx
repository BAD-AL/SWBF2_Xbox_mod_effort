Effect("Precipitation")
{
	Enable(1);
	Type("Quads");
	Texture("fx_snow");
	ParticleSize(0.015);
	Color(255, 255, 255);
	Range(15.0);
	Velocity(2.0);
	VelocityRange(0.;
	PS2()
	{
	ParticleDensity(80.0);
	}
	XBOX()
	{
	ParticleDensity(100.0);
	}
	PC()
	{
	ParticleDensity(100.0);
	}
	ParticleDensityRange(0.0);
	CameraCrossVelocityScale(1.0);
	CameraAxialVelocityScale(1.0);
	AlphaMinMax(0.3, 0.45);
	RotationRange(2.0);
}