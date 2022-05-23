using AutoMapper;

namespace HouserAPI.Profiles
{
    public class ConfigurationProfile
    {
        public MapperConfiguration Configure()
        {
            var config = new MapperConfiguration(x =>
            {
                x.AddProfile<ImageProfile>();
                x.AddProfile<MatchProfile>();
                x.AddProfile<MessageProfile>();
                x.AddProfile<RoomFilterProfile>();
                x.AddProfile<RoomProfile>();
                x.AddProfile<SwipeProfile>();
                x.AddProfile<UserFilterProfile>();
                x.AddProfile<UserProfile>();
            });
            return config;
        }
    }
}
