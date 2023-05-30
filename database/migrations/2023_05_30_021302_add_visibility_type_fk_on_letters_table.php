<?php

use App\Models\Visibility;
use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    /**
     * Run the migrations.
     */
    public function up(): void
    {
        Schema::table('letters', function (Blueprint $table) {
            $table->foreignIdFor(Visibility::class)->references('id')->on('visibility_types')->onDelete('CASCADE')->after('user_id');
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::table('letters', function(Blueprint $table){
            $table->dropForeignIdFor(Visibility::class);
        });
    }
};
