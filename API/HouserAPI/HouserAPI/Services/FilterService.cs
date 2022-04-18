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
        private readonly RoomFilterRepository _roomFilterRepository;
        private readonly IMapper _mapper;

        public FilterService(IRepository<RoomFilter> roomFilterRepository, IMapper mapper)
        {
            _roomFilterRepository = roomFilterRepository as RoomFilterRepository;
            _mapper = mapper;
        }

        public async Task<FilterReadDto> GetByUserId(string userId)
        {
            var filter = await _roomFilterRepository.GetByUserId(userId);
            switch (filter.FilterType)
            {
                case FilterType.Room:
                    return _mapper.Map<RoomFilterReadDto>(filter);
            }
            return _mapper.Map<FilterReadDto>(filter);
        }

        public async Task<FilterReadDto> Create(FilterCreateDto filterCreateDto, string userId)
        {
            if (filterCreateDto is null) throw new ArgumentNullException((nameof(filterCreateDto)));

            var filter = await GetByUserId(userId);
            if (filter != null)
            {
                switch (filterCreateDto.FilterType)
                {
                    case FilterType.Room:
                        await DeleteRoomFilter(filter.Id);
                        break;
                }
            }

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

        public async Task<bool> DeleteRoomFilter(int id)
        {
            var filter = await _roomFilterRepository.GetById(id);
            if (filter is null)
                return false;

            await _roomFilterRepository.Delete(filter);
            return await _roomFilterRepository.SaveChanges();
        }
    }
}
