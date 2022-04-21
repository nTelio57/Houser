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
        private readonly FilterRepository _filterRepository;
        private readonly IMapper _mapper;

        public FilterService(IRepository<Filter> filterRepository, IMapper mapper)
        {
            _filterRepository = filterRepository as FilterRepository;
            _mapper = mapper;
        }

        public async Task<FilterReadDto> GetByUserId(string userId)
        {
            var filter = await _filterRepository.GetByUserId(userId);
            if (filter == null)
                return null;

            switch (filter.FilterType)
            {
                case FilterType.Room:
                    return _mapper.Map<RoomFilterReadDto>(filter as RoomFilter);
                case FilterType.User:
                    return _mapper.Map<UserFilterReadDto>(filter as UserFilter);
            }
            return _mapper.Map<FilterReadDto>(filter);
        }

        public async Task<FilterReadDto> Create(FilterCreateDto filterCreateDto, string userId)
        {
            if (filterCreateDto is null) throw new ArgumentNullException((nameof(filterCreateDto)));

            var filter = await GetByUserId(userId);
            if (filter != null)
            {
                await DeleteFilter(filter.Id);
            }

            Filter filterModel = filterCreateDto.FilterType switch
            {
                FilterType.Room => _mapper.Map<RoomFilter>(filterCreateDto as RoomFilterCreateDto),
                FilterType.User => _mapper.Map<UserFilter>(filterCreateDto as UserFilterCreateDto),
                FilterType.None => throw new ArgumentException((nameof(filterCreateDto))),
                _ => throw new ArgumentException((nameof(filterCreateDto)))
            };

            filterModel.UserId = userId;
            await _filterRepository.Create(filterModel);
            await _filterRepository.SaveChanges();

            return filterCreateDto.FilterType switch
            {
                FilterType.Room => _mapper.Map<RoomFilterReadDto>(filterModel),
                FilterType.User => _mapper.Map<UserFilterReadDto>(filterModel),
                FilterType.None => throw new ArgumentException((nameof(filterCreateDto))),
                _ => throw new ArgumentException((nameof(filterCreateDto)))
            };
        }

        public async Task<bool> DeleteFilter(int id)
        {
            var filter = await _filterRepository.GetById(id);
            if (filter is null)
                return false;

            await _filterRepository.Delete(filter);
            return await _filterRepository.SaveChanges();
        }
    }
}
