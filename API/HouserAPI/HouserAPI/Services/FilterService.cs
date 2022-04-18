using System;
using System.Threading.Tasks;
using AutoMapper;
using HouserAPI.Data.Repositories;
using HouserAPI.DTOs.Filter;
using HouserAPI.Enums;
using HouserAPI.Models;

namespace HouserAPI.Services
{
    public class FilterService : IFilterService
    {
        private readonly IRepository<RoomFilter> _roomFilterRepository;
        private readonly IMapper _mapper;

        public FilterService(IRepository<RoomFilter> roomFilterRepository, IMapper mapper)
        {
            _roomFilterRepository = roomFilterRepository;
            _mapper = mapper;
        }

        public async Task<FilterReadDto> Create(FilterCreateDto filterCreateDto, string userId)
        {
            if (filterCreateDto is null) throw new ArgumentNullException((nameof(filterCreateDto)));

            switch (filterCreateDto.FilterType)
            {
                case FilterType.Room:
                    var filterModel = _mapper.Map<RoomFilter>(filterCreateDto as RoomFilterCreateDto);
                    filterModel.UserId = userId;
                    await _roomFilterRepository.Create(filterModel);
                    await _roomFilterRepository.SaveChanges();
                    return _mapper.Map<RoomFilterReadDto>(filterModel);
                default:
                    throw new ArgumentException((nameof(filterCreateDto)));
            }
        }
    }
}
