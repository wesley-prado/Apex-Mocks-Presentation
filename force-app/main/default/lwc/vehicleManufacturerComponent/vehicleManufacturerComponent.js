import { LightningElement, track } from "lwc";
import LightningAlert from "lightning/alert";
import getAllManufacturers from "@salesforce/apex/VehicleManufacturerController.getAllManufacturers";

export default class VehicleManufacturerComponent extends LightningElement {
	@track
	manufacturers = [];

	connectedCallback() {
		getAllManufacturers()
			.then((result) => {
				console.log(JSON.parse(JSON.stringify(result)));

				this.manufacturers.push(...result);
			})
			.catch(async (error) => {
				console.error("Error retrieving manufacturers", error);
				await LightningAlert.open({
					message: "Houve um erro ao carregar os fabricantes de veículos.",
					theme: "error",
					label: "Erro!"
				});
			});
	}
}
