<?php

namespace Database\Seeders;

use App\Models\Draft;
use Illuminate\Database\Console\Seeds\WithoutModelEvents;
use Illuminate\Database\Seeder;

class DraftSeeder extends Seeder
{
    /**
     * Run the database seeds.
     */
    public function run(): void
    {
        Draft::create([
            'title' => 'Draft #01',
            'content' => 'Vivamus tortor nibh, rutrum in turpis eget, fermentum porttitor lectus. Aenean feugiat lorem eu egestas malesuada. Mauris elementum pretium eros. Nullam at tempor quam, lacinia tempor magna. Ut nec ultricies turpis. Donec id maximus libero. Duis justo libero, interdum a porta eu, tincidunt lobortis metus. Sed sed ultricies ante.',
            'user_id' => 1,
        ]);

        Draft::create([
            'title' => 'Draft #01',
            'content' => 'Cras iaculis luctus pellentesque. Donec convallis sollicitudin tempor. Sed scelerisque ex et accumsan viverra. Fusce et pharetra ex, et vestibulum lorem. Integer nibh quam, pellentesque nec finibus eu, sollicitudin a felis. Nunc efficitur, dui at mattis venenatis, magna sapien mattis tellus, et sagittis massa nulla tincidunt sem. Quisque mollis neque id mi bibendum efficitur. Donec commodo magna quis eros ullamcorper facilisis.',
            'user_id' => 1,
        ]);

        Draft::create([
            'title' => 'Draft #01',
            'content' => 'Cras vitae ipsum quis mi dignissim iaculis. Curabitur aliquet in mauris eget pharetra. Duis porta ex aliquam, molestie mi eu, rhoncus velit. Integer semper magna ac ex aliquet vehicula. Phasellus et felis tincidunt, dignissim justo vel, blandit dui. Nullam vitae magna dignissim, vehicula libero vitae, accumsan elit.',
            'user_id' => 1,
        ]);
    }
}
