using System;
using System.Net.Http;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Hosting;
using Microsoft.Extensions.Hosting;

namespace HouserAPI.Services
{
    public class ApiClient
    {
        private readonly HttpClient _httpClient;

        public ApiClient(IWebHostEnvironment env)
        {
            string url = env.IsDevelopment()
                ? "http://localhost:5002"
                : "houser-app-ktu-recommendation.herokuapp.com";
            _httpClient = new HttpClient { BaseAddress = new Uri(url) };
        }

        public async Task<T> Get<T>(string path)
        {
            var response = await _httpClient.GetAsync(path);
            if (response.IsSuccessStatusCode)
            {
                return await response.Content.ReadAsAsync<T>();
            }
            throw new Exception($"Failed to get {nameof(T)}");
        }

        public async Task<T> Post<T>(string path, object value)
        {
            var response = await _httpClient.PostAsJsonAsync(path, value);
            if (response.IsSuccessStatusCode)
            {
                return await response.Content.ReadAsAsync<T>();
            }
            throw new Exception($"Failed to post {nameof(T)}");
        }


        public async Task<bool> Delete(string path)
        {
            var response = await _httpClient.DeleteAsync(path);
            if (response.IsSuccessStatusCode)
            {
                return true;
            }
            throw new Exception($"Failed to delete at {path}");
        }

        public async Task<T> Put<T>(string path, T value)
        {
            var response = await _httpClient.PutAsJsonAsync(path, value);
            if (response.IsSuccessStatusCode)
            {
                return await response.Content.ReadAsAsync<T>();
            }
            throw new Exception($"Failed to put {nameof(T)}");
        }
    }
}
