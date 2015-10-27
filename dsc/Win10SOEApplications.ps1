Configuration Win10SOEApplications
{
	Import-DscResource -ModuleName cChoco

	Node "localhost"
	{
		LocalConfigurationManager
		{
			ConfigurationMode = "ApplyAndAutoCorrect"
			ConfigurationModeFrequencyMins = 30
		}
		cChocoInstaller installChoco
		{
			InstallDir = "C:\choco"
		}
		cChocoPackageInstaller installOffice
		{
			Name = "Office365ProPlus"
			DependsOn = "[cChocoInstaller]installChoco"
		}
		cChocoPackageInstaller install7zip
		{
			Name = "7zip"
			DependsOn = "[cChocoInstaller]installChoco"
		}
		cChocoPackageInstaller installAdobeReader
		{
			Name = "adobereader"
			DependsOn = "[cChocoInstaller]installChoco"
		}
		cChocoPackageInstaller installGoogleChrome
		{
			Name = "GoogleChrome"
			DependsOn = "[cChocoInstaller]installChoco"
		}
		cChocoPackageInstaller installVLC
		{
			Name = "vlc"
			DependsOn = "[cChocoInstaller]installChoco"
		}
		cChocoPackageInstaller installSilverlight
		{
			Name = "Silverlight"
			DependsOn = "[cChocoInstaller]installChoco"
		}
		cChocoPackageInstaller installJRE
		{
			Name = "javaruntime"
			DependsOn = "[cChocoInstaller]installChoco"
		}
	}
}