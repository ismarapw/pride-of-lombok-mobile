<?php

namespace App\Http\Controllers\API;

use App\Http\Controllers\Controller;
use App\Helpers\ApiFormatter;
use Illuminate\Http\Request;
use App\Models\Pesanan;
use Illuminate\Support\Facades\Validator;
use App\Models\Marchendise;
use Illuminate\Support\Facades\DB;

class PesananController extends Controller
{

    public function buatPesanan(Request $request, $userId, $marchendiseId){
        
        $validation =  Validator::make($request->all(),[
            'jumlah' => "required|numeric|min:1",
            "alamat" => 'required|max:512',
            "metode" => 'required|max:128'
        ]); 

        if($validation ->fails()){
            return ApiFormatter::createApi(400, 'Failed', $validation->errors()); 
        }
        
        
        // ambil harga barang yang dipesan dari tabel barang
        $harga_marchendise = Marchendise::findOrFail($marchendiseId)->harga;
        
        // buat pesanan baru
        $pesanan = new Pesanan();
        $pesanan->user_id = $userId;
        $pesanan->marchendise_id = $marchendiseId;
        $pesanan->jumlah_dibeli = $request['jumlah'];
        $pesanan->total_tagihan = $pesanan->jumlah_dibeli * $harga_marchendise;
        $pesanan->alamat = $request['alamat'];
        $pesanan->metode_bayar = $request['metode'];
        
        // save pesanan ke tabel pesanan
        $pesanan->save();

        return ApiFormatter::createApi(200, 'Success', $pesanan);        
    }

    public function riwayatPesanan($user_id){
        $barang_dibeli = DB::select(
            "select pesanan.created_at,pesanan.jumlah_dibeli, 
            pesanan.total_tagihan, pesanan.alamat, pesanan.metode_bayar,
            marchendise.nama, marchendise.gambar from pesanan, marchendise 
            where pesanan.user_id = $user_id and 
            pesanan.marchendise_id = marchendise.id
            order by pesanan.created_at DESC"
        );

        return ApiFormatter::createApi(200, 'Success', $barang_dibeli); 
    }

    public function pesananMasuk() {
         // ambil semua pesanan dari tabel pesanan
         $semua_pesanan = DB::select(
            "select pesanan.created_at, 
            pesanan.jumlah_dibeli, 
            pesanan.total_tagihan, 
            pesanan.alamat, 
            pesanan.metode_bayar,
            marchendise.nama,
            marchendise.gambar,
            users.username from pesanan, users, marchendise
            where pesanan.marchendise_id = marchendise.id and pesanan.user_id = users.id order by pesanan.created_at DESC"
        );

        return ApiFormatter::createApi(200, 'Success', $semua_pesanan); 
    }

}