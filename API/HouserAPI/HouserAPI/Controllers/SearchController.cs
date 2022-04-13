using Microsoft.AspNetCore.Mvc;
using System.Threading.Tasks;
using HouserAPI.Services;

namespace HouserAPI.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class SearchController : ControllerBase
    {
        private readonly ISearchService _searchService;

        public SearchController(ISearchService searchService)
        {
            _searchService = searchService;
        }

        [HttpGet]
        public async Task<IActionResult> GetRecommendationByFilter(int id)
        {
            var offerReadDto = await _searchService.GetRecommendationByFilter();
            if (offerReadDto is null)
                return NotFound();

            return Ok(offerReadDto);
        }
    }
}
