using System;
using Microsoft.EntityFrameworkCore.Migrations;
using MySql.EntityFrameworkCore.Metadata;

namespace HouserAPI.Migrations
{
    public partial class Init : Migration
    {
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.CreateTable(
                name: "AspNetRoles",
                columns: table => new
                {
                    Id = table.Column<string>(type: "varchar(255)", nullable: false),
                    Name = table.Column<string>(type: "varchar(255)", maxLength: 255, nullable: true),
                    NormalizedName = table.Column<string>(type: "varchar(255)", maxLength: 255, nullable: true),
                    ConcurrencyStamp = table.Column<string>(type: "text", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_AspNetRoles", x => x.Id);
                });

            migrationBuilder.CreateTable(
                name: "AspNetUsers",
                columns: table => new
                {
                    Id = table.Column<string>(type: "varchar(255)", nullable: false),
                    IsVisible = table.Column<bool>(type: "tinyint(1)", nullable: false),
                    Salt = table.Column<string>(type: "text", nullable: true),
                    Elo = table.Column<int>(type: "int", nullable: false),
                    Name = table.Column<string>(type: "text", nullable: true),
                    Surname = table.Column<string>(type: "text", nullable: true),
                    City = table.Column<string>(type: "text", nullable: true),
                    BirthDate = table.Column<DateTime>(type: "datetime", nullable: false),
                    Sex = table.Column<int>(type: "int", nullable: false),
                    AnimalCount = table.Column<int>(type: "int", nullable: false),
                    IsStudying = table.Column<bool>(type: "tinyint(1)", nullable: false),
                    IsWorking = table.Column<bool>(type: "tinyint(1)", nullable: false),
                    IsSmoking = table.Column<bool>(type: "tinyint(1)", nullable: false),
                    SleepType = table.Column<int>(type: "int", nullable: false),
                    GuestCount = table.Column<int>(type: "int", nullable: false),
                    PartyCount = table.Column<int>(type: "int", nullable: false),
                    UserName = table.Column<string>(type: "varchar(255)", maxLength: 255, nullable: true),
                    NormalizedUserName = table.Column<string>(type: "varchar(255)", maxLength: 255, nullable: true),
                    Email = table.Column<string>(type: "varchar(255)", maxLength: 255, nullable: true),
                    NormalizedEmail = table.Column<string>(type: "varchar(255)", maxLength: 255, nullable: true),
                    EmailConfirmed = table.Column<bool>(type: "tinyint(1)", nullable: false),
                    PasswordHash = table.Column<string>(type: "text", nullable: true),
                    SecurityStamp = table.Column<string>(type: "text", nullable: true),
                    ConcurrencyStamp = table.Column<string>(type: "text", nullable: true),
                    PhoneNumber = table.Column<string>(type: "text", nullable: true),
                    PhoneNumberConfirmed = table.Column<bool>(type: "tinyint(1)", nullable: false),
                    TwoFactorEnabled = table.Column<bool>(type: "tinyint(1)", nullable: false),
                    LockoutEnd = table.Column<DateTimeOffset>(type: "timestamp", nullable: true),
                    LockoutEnabled = table.Column<bool>(type: "tinyint(1)", nullable: false),
                    AccessFailedCount = table.Column<int>(type: "int", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_AspNetUsers", x => x.Id);
                });

            migrationBuilder.CreateTable(
                name: "AspNetRoleClaims",
                columns: table => new
                {
                    Id = table.Column<int>(type: "int", nullable: false)
                        .Annotation("MySQL:ValueGenerationStrategy", MySQLValueGenerationStrategy.IdentityColumn),
                    RoleId = table.Column<string>(type: "varchar(255)", nullable: false),
                    ClaimType = table.Column<string>(type: "text", nullable: true),
                    ClaimValue = table.Column<string>(type: "text", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_AspNetRoleClaims", x => x.Id);
                    table.ForeignKey(
                        name: "FK_AspNetRoleClaims_AspNetRoles_RoleId",
                        column: x => x.RoleId,
                        principalTable: "AspNetRoles",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateTable(
                name: "AspNetUserClaims",
                columns: table => new
                {
                    Id = table.Column<int>(type: "int", nullable: false)
                        .Annotation("MySQL:ValueGenerationStrategy", MySQLValueGenerationStrategy.IdentityColumn),
                    UserId = table.Column<string>(type: "varchar(255)", nullable: false),
                    ClaimType = table.Column<string>(type: "text", nullable: true),
                    ClaimValue = table.Column<string>(type: "text", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_AspNetUserClaims", x => x.Id);
                    table.ForeignKey(
                        name: "FK_AspNetUserClaims_AspNetUsers_UserId",
                        column: x => x.UserId,
                        principalTable: "AspNetUsers",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateTable(
                name: "AspNetUserLogins",
                columns: table => new
                {
                    LoginProvider = table.Column<string>(type: "varchar(255)", nullable: false),
                    ProviderKey = table.Column<string>(type: "varchar(255)", nullable: false),
                    ProviderDisplayName = table.Column<string>(type: "text", nullable: true),
                    UserId = table.Column<string>(type: "varchar(255)", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_AspNetUserLogins", x => new { x.LoginProvider, x.ProviderKey });
                    table.ForeignKey(
                        name: "FK_AspNetUserLogins_AspNetUsers_UserId",
                        column: x => x.UserId,
                        principalTable: "AspNetUsers",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateTable(
                name: "AspNetUserRoles",
                columns: table => new
                {
                    UserId = table.Column<string>(type: "varchar(255)", nullable: false),
                    RoleId = table.Column<string>(type: "varchar(255)", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_AspNetUserRoles", x => new { x.UserId, x.RoleId });
                    table.ForeignKey(
                        name: "FK_AspNetUserRoles_AspNetRoles_RoleId",
                        column: x => x.RoleId,
                        principalTable: "AspNetRoles",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                    table.ForeignKey(
                        name: "FK_AspNetUserRoles_AspNetUsers_UserId",
                        column: x => x.UserId,
                        principalTable: "AspNetUsers",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateTable(
                name: "AspNetUserTokens",
                columns: table => new
                {
                    UserId = table.Column<string>(type: "varchar(255)", nullable: false),
                    LoginProvider = table.Column<string>(type: "varchar(255)", nullable: false),
                    Name = table.Column<string>(type: "varchar(255)", nullable: false),
                    Value = table.Column<string>(type: "text", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_AspNetUserTokens", x => new { x.UserId, x.LoginProvider, x.Name });
                    table.ForeignKey(
                        name: "FK_AspNetUserTokens_AspNetUsers_UserId",
                        column: x => x.UserId,
                        principalTable: "AspNetUsers",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateTable(
                name: "Filters",
                columns: table => new
                {
                    Id = table.Column<int>(type: "int", nullable: false)
                        .Annotation("MySQL:ValueGenerationStrategy", MySQLValueGenerationStrategy.IdentityColumn),
                    UserId = table.Column<string>(type: "varchar(255)", nullable: true),
                    Elo = table.Column<int>(type: "int", nullable: false),
                    FilterType = table.Column<int>(type: "int", nullable: false),
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
                    table.PrimaryKey("PK_Filters", x => x.Id);
                    table.ForeignKey(
                        name: "FK_Filters_AspNetUsers_UserId",
                        column: x => x.UserId,
                        principalTable: "AspNetUsers",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Restrict);
                });

            migrationBuilder.CreateTable(
                name: "Rooms",
                columns: table => new
                {
                    Id = table.Column<int>(type: "int", nullable: false)
                        .Annotation("MySQL:ValueGenerationStrategy", MySQLValueGenerationStrategy.IdentityColumn),
                    IsVisible = table.Column<bool>(type: "tinyint(1)", nullable: false),
                    UploadDate = table.Column<DateTime>(type: "datetime", nullable: false),
                    Title = table.Column<string>(type: "text", nullable: true),
                    City = table.Column<string>(type: "text", nullable: true),
                    Address = table.Column<string>(type: "text", nullable: true),
                    MonthlyPrice = table.Column<float>(type: "float", nullable: false),
                    UtilityBillsRequired = table.Column<bool>(type: "tinyint(1)", nullable: false),
                    Area = table.Column<float>(type: "float", nullable: false),
                    AvailableFrom = table.Column<DateTime>(type: "datetime", nullable: false),
                    AvailableTo = table.Column<DateTime>(type: "datetime", nullable: false),
                    FreeRoomCount = table.Column<int>(type: "int", nullable: false),
                    TotalRoomCount = table.Column<int>(type: "int", nullable: false),
                    BedCount = table.Column<int>(type: "int", nullable: false),
                    BedType = table.Column<int>(type: "int", nullable: false),
                    RuleSmoking = table.Column<bool>(type: "tinyint(1)", nullable: false),
                    RuleAnimals = table.Column<bool>(type: "tinyint(1)", nullable: false),
                    AccommodationTv = table.Column<bool>(type: "tinyint(1)", nullable: false),
                    AccommodationWifi = table.Column<bool>(type: "tinyint(1)", nullable: false),
                    AccommodationAc = table.Column<bool>(type: "tinyint(1)", nullable: false),
                    AccommodationParking = table.Column<bool>(type: "tinyint(1)", nullable: false),
                    AccommodationBalcony = table.Column<bool>(type: "tinyint(1)", nullable: false),
                    AccommodationDisability = table.Column<bool>(type: "tinyint(1)", nullable: false),
                    UserId = table.Column<string>(type: "varchar(255)", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Rooms", x => x.Id);
                    table.ForeignKey(
                        name: "FK_Rooms_AspNetUsers_UserId",
                        column: x => x.UserId,
                        principalTable: "AspNetUsers",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Restrict);
                });

            migrationBuilder.CreateTable(
                name: "Images",
                columns: table => new
                {
                    Id = table.Column<int>(type: "int", nullable: false)
                        .Annotation("MySQL:ValueGenerationStrategy", MySQLValueGenerationStrategy.IdentityColumn),
                    Path = table.Column<string>(type: "text", nullable: true),
                    IsMain = table.Column<bool>(type: "tinyint(1)", nullable: false),
                    UserId = table.Column<string>(type: "varchar(255)", nullable: true),
                    RoomId = table.Column<int>(type: "int", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Images", x => x.Id);
                    table.ForeignKey(
                        name: "FK_Images_AspNetUsers_UserId",
                        column: x => x.UserId,
                        principalTable: "AspNetUsers",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Restrict);
                    table.ForeignKey(
                        name: "FK_Images_Rooms_RoomId",
                        column: x => x.RoomId,
                        principalTable: "Rooms",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Restrict);
                });

            migrationBuilder.CreateIndex(
                name: "IX_AspNetRoleClaims_RoleId",
                table: "AspNetRoleClaims",
                column: "RoleId");

            migrationBuilder.CreateIndex(
                name: "RoleNameIndex",
                table: "AspNetRoles",
                column: "NormalizedName",
                unique: true);

            migrationBuilder.CreateIndex(
                name: "IX_AspNetUserClaims_UserId",
                table: "AspNetUserClaims",
                column: "UserId");

            migrationBuilder.CreateIndex(
                name: "IX_AspNetUserLogins_UserId",
                table: "AspNetUserLogins",
                column: "UserId");

            migrationBuilder.CreateIndex(
                name: "IX_AspNetUserRoles_RoleId",
                table: "AspNetUserRoles",
                column: "RoleId");

            migrationBuilder.CreateIndex(
                name: "EmailIndex",
                table: "AspNetUsers",
                column: "NormalizedEmail");

            migrationBuilder.CreateIndex(
                name: "UserNameIndex",
                table: "AspNetUsers",
                column: "NormalizedUserName",
                unique: true);

            migrationBuilder.CreateIndex(
                name: "IX_Filters_UserId",
                table: "Filters",
                column: "UserId",
                unique: true);

            migrationBuilder.CreateIndex(
                name: "IX_Images_RoomId",
                table: "Images",
                column: "RoomId");

            migrationBuilder.CreateIndex(
                name: "IX_Images_UserId",
                table: "Images",
                column: "UserId");

            migrationBuilder.CreateIndex(
                name: "IX_Rooms_UserId",
                table: "Rooms",
                column: "UserId");
        }

        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropTable(
                name: "AspNetRoleClaims");

            migrationBuilder.DropTable(
                name: "AspNetUserClaims");

            migrationBuilder.DropTable(
                name: "AspNetUserLogins");

            migrationBuilder.DropTable(
                name: "AspNetUserRoles");

            migrationBuilder.DropTable(
                name: "AspNetUserTokens");

            migrationBuilder.DropTable(
                name: "Filters");

            migrationBuilder.DropTable(
                name: "Images");

            migrationBuilder.DropTable(
                name: "AspNetRoles");

            migrationBuilder.DropTable(
                name: "Rooms");

            migrationBuilder.DropTable(
                name: "AspNetUsers");
        }
    }
}
