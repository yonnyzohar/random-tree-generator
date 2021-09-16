package {
	import flash.geom.Point;
	import flash.utils.setTimeout;
	import flash.events.MouseEvent;
	import flash.display.MovieClip;


	public class Main extends MovieClip {


		var numBranches: Number = 3;
		var total: int = 0;
		var totalPower: int = 60 * numBranches;
		var power: Number = totalPower;
		var erosion: Number = -1;
		var baseAngleAmount: Number = 40;
		var angleAmount: Number = baseAngleAmount;
		var rootObj: Object;
		var maxVal: Number = 0;
		var totalRadius: Number = 20;
		var mc: MovieClip;

		var numLines: int = 20;

		public function Main() {
			stage.scaleMode = "noScale";
			stage.addEventListener(MouseEvent.CLICK, createTree);
			mc = this;
		}




		function getLength(): Number {
			return Number(Math.random() * (50 * numBranches));
		}

		function randomRange(minNum: Number, maxNum: Number): Number {
			return (Math.floor(Math.random() * (maxNum - minNum + 1)) + minNum);
		}

		function createTree(e: MouseEvent): void {

			while (numChildren) {
				removeChildAt(0);
			}
			total = 0;
			maxVal = 0;
			this.graphics.clear();
			angleAmount = baseAngleAmount;
			power = totalPower;
			rootObj = {
				x: stage.stageWidth / 2,
				y: stage.stageHeight - 50,
				angle: -90,
				parent: null,
				num: null,
				children: []
			};

			mc.graphics.lineStyle(0.1, 0x000000);
			createPoint(rootObj);

			setTimeout(function () {
				mc.graphics.lineStyle(0.1, 0x663300);
				setAllRings(rootObj);
			}, totalPower * 2);

		}

		function getCurrentPoint(obj: Object, degree: Number): Point {
			var per: Number = obj.num / maxVal;
			var currRadius: Number = totalRadius * per;
			var pointAngleRadians: Number = degree * Math.PI / 180;
			var newPointX: Number = Math.cos(pointAngleRadians) * currRadius;
			var newPointY: Number = Math.sin(pointAngleRadians) * currRadius;
			newPointX += obj.x;
			newPointY += obj.y;
			return new Point(newPointX, newPointY);
		}

		function setAllRings(obj: Object): void {
			var diff: Number = 360 / numLines;
			var curr: Number = 0;
			var per: Number = obj.num / maxVal;
			var currRadius: Number = totalRadius * per;
			mc.graphics.drawCircle(obj.x, obj.y, currRadius);

			for (var j: int = 0; j < numLines; j++) {
				setTimeout(function () {
					curr += diff;
					var p: Point;


					if (obj.children != null && obj.children.length) {
						for (var ii: int = 0; ii < obj.children.length; ii++) {
							p = getCurrentPoint(obj, curr);
							mc.graphics.moveTo(p.x, p.y);
							p = getCurrentPoint(obj.children[ii], curr);
							mc.graphics.lineTo(p.x, p.y);
						}
					}
				}, 1);
			}


			if (obj.children != null && obj.children.length) {

				for (var i: int = 0; i < obj.children.length; i++) {
					var child: Object = obj.children[i];
					setTimeout(function (c: Object) {
						setAllRings(c);
					}, 10, child);
				}


			}


		}

		function createPoint(obj: Object): void {
			mc.graphics.moveTo(obj.x, obj.y);

			var pointAngle: Number = randomRange(obj.angle - angleAmount, obj.angle + angleAmount);

			var pointAngleRadians: Number = pointAngle * Math.PI / 180;
			var pointRadius: Number = getLength();
			var newPointX: Number = Math.cos(pointAngleRadians) * pointRadius;
			var newPointY: Number = Math.sin(pointAngleRadians) * pointRadius;
			obj.radiousToNextPoint = Number(pointRadius);


			//create the destination point
			var nextPoint: Object = {
				x: obj.x + newPointX,
				y: obj.y + newPointY,
				angle: pointAngle,
				parent: obj,
				num: null,
				children: []
			}
			obj.children.push(nextPoint);

			mc.graphics.lineTo(obj.x + newPointX, obj.y + newPointY);

			var rnd: int = (Math.random() * numBranches) + 1;
			angleAmount += 0.1;
			if (power > 0) {
				setTimeout(function () {
					for (var i: int = 0; i < rnd; i++) {
						if (power > 0) {
							power += erosion;
							createPoint(nextPoint);
						} else {
							setNum(nextPoint, 0);
							break;
						}
					}

				}, 1);
			} else {
				setNum(nextPoint, 0);
			}

		}

		function setNum(obj: Object, num: int): void {
			var changed: Boolean = false;
			if (obj.num == null) {
				changed = true;
				obj.num = num;

			} else {
				if (num > obj.num) {
					changed = true;
					obj.num = num;

				}
			}


			if (obj.parent != null) {
				setNum(obj.parent, num + 1);
			} else {
				if (changed) {
					maxVal = num;
				}

			}
		}


	}

}