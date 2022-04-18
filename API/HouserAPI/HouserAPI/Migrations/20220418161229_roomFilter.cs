using System;
using Microsoft.EntityFrameworkCore.Migrations;
using MySql.EntityFrameworkCore.Metadata;

namespace HouserAPI.Migrations
{
    public partial class roomFilter : Migration
    {
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.CreateTable(
                name: "Filter",
                columns: table => new
                {
                    Id = table.Column<int>(type: "int", nullable: false)
                        .Annotation("MySQL:ValueGenerationStrategy", MySQLValueGenerationStrategy.IdentityColumn),
                    UserId = table.Column<string>(type: "varchar(255)", nullable: true),
                    Elo = table.Column<int>(type: "int", nullable: false),
                    FilterType = table.Column<int>(type: "int", nullable: false),
                    Discriminator = table.Column<string>(type: "text", nullable: false),
                    Area = table.Column<float>(type: "float", nullable: true),
                    MonthlyPrice = table.Column<float>(type: "float", nullable: true),
                    City = table.Column<string>(type: "text", nullable: true),
                    AvailableFrom = table.Column<DateTime>(type: "datetime", nullable: true),
                    AvailableTo = table.Column<DateTime>(type: "datetime", nullable: true),
                    FreeRoomCount = table.Column<int>(type: "int", nullable: true),
                    BedCount = table.Column<int>(type: "int", nullable: true),
                    RuleSmoking = table.Column<bool>(type: "tinyint(1)", nullable: true),
                    RuleAnimals = table.Column<bool>(type: "tinyint(1)", nullable: true),
                    AccommodationTv = table.Column<bool>(type: "tinyint(1)", nullable: true),
                    AccommodationWifi = table.Column<bool>(type: "tinyint(1)", nullable: true),
                    AccommodationAc = table.Column<bool>(type: "tinyint(1)", nullable: true),
                    AccommodationParking = table.Column<bool>(type: "tinyint(1)", nullable: true),
                    AccommodationBalcony = table.Column<bool>(type: "tinyint(1)", nullable: true),
                    AccommodationDisability = table.Column<bool>(type: "tinyint(1)", nullable: true),
                    AgeFrom = table.Column<int>(type: "int", nullable: true),
                    AgeTo = table.Column<int>(type: "int", nullable: true),
                    Sex = table.Column<int>(type: "int", nullable: true),
                    AnimalCount = table.Column<int>(type: "int", nullable: true),
                    IsStudying = table.Column<bool>(type: "tinyint(1)", nullable: true),
                    IsWorking = table.Column<bool>(type: "tinyint(1)", nullable: true),
                    IsSmoking = table.Column<bool>(type: "tinyint(1)", nullable: true),
                    GuestCount = table.Column<int>(type: "int", nullable: true),
                    PartyCount = table.Column<int>(type: "int", nullable: true),
                    SleepType = table.Column<int>(type: "int", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Filter", x => x.Id);
                    table.ForeignKey(
                        name: "FK_Filter_AspNetUsers_UserId",
                        column: x => x.UserId,
                        principalTable: "AspNetUsers",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Restrict);
                });

            migrationBuilder.CreateIndex(
                name: "IX_Filter_UserId",
                table: "Filter",
                column: "UserId",
                unique: true);
        }

        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropTable(
                name: "Filter");
        }
    }
}
