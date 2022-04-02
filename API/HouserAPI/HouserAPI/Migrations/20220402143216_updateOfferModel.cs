using Microsoft.EntityFrameworkCore.Migrations;

namespace HouserAPI.Migrations
{
    public partial class updateOfferModel : Migration
    {
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.AddColumn<bool>(
                name: "AccommodationBalcony",
                table: "Offers",
                type: "tinyint(1)",
                nullable: false,
                defaultValue: false);

            migrationBuilder.AddColumn<bool>(
                name: "AccommodationDisability",
                table: "Offers",
                type: "tinyint(1)",
                nullable: false,
                defaultValue: false);

            migrationBuilder.AddColumn<bool>(
                name: "AccommodationParking",
                table: "Offers",
                type: "tinyint(1)",
                nullable: false,
                defaultValue: false);

            migrationBuilder.AddColumn<float>(
                name: "Area",
                table: "Offers",
                type: "float",
                nullable: false,
                defaultValue: 0f);
        }

        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropColumn(
                name: "AccommodationBalcony",
                table: "Offers");

            migrationBuilder.DropColumn(
                name: "AccommodationDisability",
                table: "Offers");

            migrationBuilder.DropColumn(
                name: "AccommodationParking",
                table: "Offers");

            migrationBuilder.DropColumn(
                name: "Area",
                table: "Offers");
        }
    }
}
