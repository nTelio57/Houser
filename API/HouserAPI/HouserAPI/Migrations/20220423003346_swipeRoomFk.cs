using Microsoft.EntityFrameworkCore.Migrations;

namespace HouserAPI.Migrations
{
    public partial class swipeRoomFk : Migration
    {
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "FK_Swipes_Rooms_RoomId",
                table: "Swipes");

            migrationBuilder.AlterColumn<int>(
                name: "RoomId",
                table: "Swipes",
                type: "int",
                nullable: true,
                oldClrType: typeof(int),
                oldType: "int");

            migrationBuilder.AddForeignKey(
                name: "FK_Swipes_Rooms_RoomId",
                table: "Swipes",
                column: "RoomId",
                principalTable: "Rooms",
                principalColumn: "Id",
                onDelete: ReferentialAction.Restrict);
        }

        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "FK_Swipes_Rooms_RoomId",
                table: "Swipes");

            migrationBuilder.AlterColumn<int>(
                name: "RoomId",
                table: "Swipes",
                type: "int",
                nullable: false,
                defaultValue: 0,
                oldClrType: typeof(int),
                oldType: "int",
                oldNullable: true);

            migrationBuilder.AddForeignKey(
                name: "FK_Swipes_Rooms_RoomId",
                table: "Swipes",
                column: "RoomId",
                principalTable: "Rooms",
                principalColumn: "Id",
                onDelete: ReferentialAction.Cascade);
        }
    }
}
