using AssettoServer.Server.Plugin;
using AssettoServer.Server.Weather.Implementation;
using Autofac;
using Microsoft.Extensions.Hosting;

namespace VenomPersonalTimePlugin;

public sealed class VenomPersonalTimeModule : AssettoServerModule<VenomPersonalTimeConfiguration>
{
    protected override void Load(ContainerBuilder builder)
    {
        builder.RegisterType<VenomPersonalTimeService>().AsSelf().SingleInstance();
        builder.RegisterDecorator<VenomPersonalWeatherDecorator, IWeatherImplementation>();
        builder.RegisterType<VenomPersonalTimePlugin>().AsSelf().As<IHostedService>().SingleInstance();
    }
}
