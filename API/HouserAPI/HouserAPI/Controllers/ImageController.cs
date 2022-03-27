using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using System;
using System.IO;
using System.Threading.Tasks;
using HouserAPI.Auth;
using HouserAPI.Services;
using Microsoft.AspNetCore.Authorization;

namespace HouserAPI.Controllers
{
    [Authorize]
    [Route("api/[controller]")]
    [ApiController]
    public class ImageController : ControllerBase
    {
        private readonly IImageService _imageService;

        public ImageController(IImageService imageService)
        {
            _imageService = imageService;
        }

        [HttpPost]
        [Roles(UserRoles.Basic)]
        public async Task<IActionResult> PostImage(IFormFile image)
        {
            var userId = User.FindFirst(CustomClaims.UserId)?.Value;

            if(image == null)
                return BadRequest("Value cannot be null.");

            try
            {
                var imageReadDto = await _imageService.Create(userId, image);
                return CreatedAtAction(nameof(PostImage), imageReadDto);
            }
            catch (Exception)
            {
                return BadRequest("Failed to post image.");
            }
        }

        [HttpGet]
        [Roles(UserRoles.Admin)]
        public async Task<IActionResult> GetAllImages()
        {
            var images = await _imageService.GetAll();
            return Ok(images);
        }

        [HttpGet("user/{id}")]
        [Roles(UserRoles.Basic)]
        public async Task<IActionResult> GetAllImagesByUser(string id)
        {
            var userId = User.FindFirst(CustomClaims.UserId)?.Value;
            if (userId != id)
                return Forbid();

            var images = await _imageService.GetAllByUser(id);
            return Ok(images);
        }

        [HttpGet("{id}", Name = "GetImageById")]
        [Roles(UserRoles.Basic)]
        public async Task<IActionResult> GetImageById(int id)
        {
            var userId = User.FindFirst(CustomClaims.UserId)?.Value;

            var image = await _imageService.GetById(id);
            if (image == null) 
                return NotFound();

            if (!image.UserId.Equals(userId)) 
                return Forbid();

            try
            {
                var imageStream = System.IO.File.OpenRead(image.Path);
                return File(imageStream, "image/png");
            }
            catch (Exception e)
            {
                if(e is FileNotFoundException || e is DirectoryNotFoundException)
                    return BadRequest("Image file was not found.");

                return BadRequest("Failed to post image.");
            }
        }

        [HttpDelete("{id}")]
        [Roles(UserRoles.Basic)]
        public async Task<IActionResult> DeleteImage(int id)
        {
            var userId = User.FindFirst(CustomClaims.UserId)?.Value;

            var image = await _imageService.GetById(id);
            if (image == null) 
                return NotFound();

            if (!image.UserId.Equals(userId))
                return Forbid();

            try
            {
                await _imageService.Delete(id);
                return NoContent();
            }
            catch (Exception)
            {
                return BadRequest("Failed to delete image.");
            }
        }
    }
}
