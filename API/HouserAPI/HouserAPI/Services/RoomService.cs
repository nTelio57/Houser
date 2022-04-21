using System;
using System.Collections.Generic;
using System.Threading.Tasks;
using AutoMapper;
using HouserAPI.Data.Repositories;
using HouserAPI.DTOs.Room;
using HouserAPI.Models;

namespace HouserAPI.Services
{
    public class RoomService : IRoomService
    {
        private readonly RoomRepository _repository;
        private readonly IMapper _mapper;

        public RoomService(IRepository<Room> repository, IMapper mapper)
        {
            _repository = repository as RoomRepository;
            _mapper = mapper;
        }

        public async Task<RoomReadDto> Create(RoomCreateDto roomCreateDto)
        {
            if (roomCreateDto is null) throw new ArgumentNullException((nameof(roomCreateDto)));

            var roomModel = _mapper.Map<Room>(roomCreateDto);
            await _repository.Create(roomModel);
            await _repository.SaveChanges();

            return _mapper.Map<RoomReadDto>(roomModel);
        }

        public async Task<IEnumerable<RoomReadDto>> GetAll()
        {
            throw new NotImplementedException();
        }

        public async Task<RoomReadDto> GetById(int id)
        {
            var room = await _repository.GetById(id);
            return _mapper.Map<RoomReadDto>(room);
        }

        public async Task<IEnumerable<RoomReadDto>> GetAllByUser(string id)
        {
            var rooms = await _repository.GetAllByUser(id);
            return _mapper.Map<IEnumerable<RoomReadDto>>(rooms);
        }

        public async Task<bool> Update(int id, RoomUpdateDto roomUpdateDto)
        {
            var room = await _repository.GetById(id);
            _mapper.Map(roomUpdateDto, room);
            await _repository.Update(room);
            return await _repository.SaveChanges();
        }

        public async Task<bool> Delete(int id)
        {
            var room = await _repository.GetById(id);
            if (room is null)
                return false;

            await _repository.Delete(room);
            return await _repository.SaveChanges();
        }
    }
}
