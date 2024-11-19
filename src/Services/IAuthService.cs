namespace TorosClient.src.Services;
public interface IAuthService
{
    Task<bool> LoginAsync(LoginRequest loginRequest);
    Task LogoutAsync();
    Task<bool> IsAuthenticatedAsync();
}